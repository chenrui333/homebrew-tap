class Monitui < Formula
  desc "Delightfully minimal TUI for wrangling Hyprland monitors"
  homepage "https://github.com/nathaniel-fargo/monitui"
  url "https://github.com/nathaniel-fargo/monitui/archive/8d69ac3f437073ef181866c2a20aac345bf27718.tar.gz"
  version "0.2.3"
  sha256 "c9323d8b6fefa739e9aeba9a07fe6c15b3133ff475f6cb2d837c31ea5c4e3129"
  license "MIT"
  head "https://github.com/nathaniel-fargo/monitui.git", branch: "main"

  livecheck do
    skip "no tagged releases"
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "26383a4ef0c055352385b1997222737ccf25ec08928904d8da75d5177e275fef"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2c824557421ea50b2f17f6c4e1245f3dccc42c5e421e183047787fba930ab87a"
  end

  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/monitui --help")

    monitor_json = testpath/"monitors.json"
    monitor_json.write <<~JSON
      [
        {"id":0,"name":"eDP-1","description":"Built-in","make":"Apple","model":"Display","serial":"1","width":1728,"height":1117,"refreshRate":60.0,"x":0,"y":0,"activeWorkspace":{"id":1,"name":"1"},"specialWorkspace":{"id":0,"name":""},"reserved":[0,0,0,0],"scale":2.0,"transform":0,"focused":true,"dpmsStatus":true,"vrr":false,"activelyTearing":false,"disabled":false,"currentFormat":"XRGB8888","availableModes":["1728x1117@60"]},
        {"id":1,"name":"HDMI-A-1","description":"External","make":"Dell","model":"U2720Q","serial":"2","width":3840,"height":2160,"refreshRate":60.0,"x":1728,"y":0,"activeWorkspace":{"id":2,"name":"2"},"specialWorkspace":{"id":0,"name":""},"reserved":[0,0,0,0],"scale":1.0,"transform":0,"focused":false,"dpmsStatus":true,"vrr":false,"activelyTearing":false,"disabled":true,"currentFormat":"XRGB8888","availableModes":["3840x2160@60"]}
      ]
    JSON

    (testpath/"bin").mkpath
    (testpath/"bin/hyprctl").write <<~SH
      #!/bin/sh
      if [ "$1" = "-j" ] && [ "$2" = "monitors" ] && [ "$3" = "all" ]; then
        cat "#{monitor_json}"
      else
        echo "unexpected hyprctl args: $*" >&2
        exit 1
      fi
    SH
    chmod 0755, testpath/"bin/hyprctl"

    assert_match "\"name\":\"eDP-1\"", shell_output("#{testpath}/bin/hyprctl -j monitors all")

    output = shell_output("env PATH=#{testpath}/bin:#{ENV.fetch("PATH")} #{bin}/monitui --list")
    assert_match "eDP-1 - enabled", output
    assert_match "HDMI-A-1 - DISABLED", output
  end
end
