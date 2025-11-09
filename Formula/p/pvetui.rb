class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "5860aef8b99ea2d540a6b8830e1605a07c83f69f4e9f617de9d60e36562e0ed3"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/devnullvoid/pvetui/internal/version.version=#{version}
      -X github.com/devnullvoid/pvetui/internal/version.commit=#{tap.user}
      -X github.com/devnullvoid/pvetui/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pvetui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pvetui --version")
  end
end
