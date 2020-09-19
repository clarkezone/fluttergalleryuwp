#include "pch.h"
#include <concrt.h>
#include <ppltasks.h>
#include <windows.ui.composition.h>

#include <chrono>  //these should be at the bottom
#include <memory>
#include <thread>

#include "winrt/Windows.ApplicationModel.Core.h"
#include "winrt/Windows.Foundation.h"
#include "winrt/Windows.System.Profile.h"
#include "winrt/Windows.System.Threading.h"
#include "winrt/Windows.UI.Core.h"

#include <cpp_client_wrapper_winrt/include/flutter/plugin_registry.h>


using namespace winrt;
using namespace Windows;
using namespace Windows::ApplicationModel::Core;
using namespace Windows::Foundation::Numerics;
using namespace Windows::UI;
using namespace Windows::Foundation;
using namespace Windows::UI::Core;

struct App : winrt::implements<App, IFrameworkViewSource, IFrameworkView> {
    std::unique_ptr<flutter::FlutterViewControllerWinRT> m_flutterController{ nullptr };

    IFrameworkView CreateView() { return *this; }

    void Initialize(CoreApplicationView const&) {
        //Must be disabled in the Initialize method in order to take effect
        if (winrt::Windows::System::Profile::AnalyticsInfo::VersionInfo().DeviceFamily() == L"Windows.Xbox") {

            bool result = winrt::Windows::UI::ViewManagement::ApplicationViewScaling::TrySetDisableLayoutScaling(true);
            if (!result) {
                OutputDebugString(L"Couldn't disable layout scaling");
            }
        }
    }

    void Load(hstring const&) {}

    void Uninitialize() {}

    void Run() {
        CoreWindow window = CoreWindow::GetForCurrentThread();
        window.Activate();

        CoreDispatcher dispatcher = window.Dispatcher();
        dispatcher.ProcessEvents(CoreProcessEventsOption::ProcessUntilQuit);
    }

    // Required to avoid window object being released
    CoreWindow window_{ nullptr };

    winrt::Windows::Foundation::IAsyncAction SetWindow(CoreWindow const& window) {
        //Ensure we have a reference to the window as there are corouting
        window_ = window;
        auto appView =
            winrt::Windows::UI::ViewManagement::ApplicationView::GetForCurrentView();

        appView.SetDesiredBoundsMode(
            Windows::UI::ViewManagement::ApplicationViewBoundsMode::UseCoreWindow);

        window.PointerReleased([&](auto&&...) {});

        try {
            winrt::Windows::Storage::StorageFolder folder =
                winrt::Windows::ApplicationModel::Package::Current().InstalledLocation();

            winrt::Windows::Storage::StorageFolder assets =
                co_await folder.GetFolderAsync(L"Assets");
            winrt::Windows::Storage::StorageFolder data =
                co_await assets.GetFolderAsync(L"data");
            winrt::Windows::Storage::StorageFolder flutter_assets =
                co_await data.GetFolderAsync(L"flutter_assets");
            winrt::Windows::Storage::StorageFile icu_data =
                co_await data.GetFileAsync(L"icudtl.dat");

#if NDEBUG
			winrt::Windows::Storage::StorageFile aot_data =
				co_await data.GetFileAsync(L"app.so");
#endif

			std::wstring flutter_assets_path{ flutter_assets.Path() };
			std::wstring icu_data_path{ icu_data.Path() };
			std::wstring aot_data_path{
#if NDEBUG                
				aot_data.Path()
#endif            
			};

            flutter::DartProjectWinRT project(flutter_assets_path, icu_data_path, aot_data_path);

            m_flutterController = std::make_unique<flutter::FlutterViewControllerWinRT>( static_cast<ABI::Windows::UI::Core::CoreWindow*>(winrt::get_abi(window_)), project);

            RegisterPlugins(m_flutterController.get());
        }
        catch (winrt::hresult_error& err) {
            winrt::Windows::UI::Popups::MessageDialog md = winrt::Windows::UI::Popups::MessageDialog::MessageDialog(L"There was a problem starting the engine: " + err.message());
            md.ShowAsync();
        }
    }

    void RegisterPlugins(flutter::PluginRegistry*) {
      
    }
};

int __stdcall wWinMain(HINSTANCE, HINSTANCE, PWSTR, int) {
    CoreApplication::Run(make<App>());
}
