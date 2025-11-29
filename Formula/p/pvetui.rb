class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.0.13.tar.gz"
  sha256 "dcab0cb52076cc7fe1314f8d2a1d6e65fc59f3307ff037753cae2fd18516073f"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "addc0fc853ddd9e1818fdcf46df3b269f57a5920c6de16ba7c516913dd2d7b07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "addc0fc853ddd9e1818fdcf46df3b269f57a5920c6de16ba7c516913dd2d7b07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "addc0fc853ddd9e1818fdcf46df3b269f57a5920c6de16ba7c516913dd2d7b07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7aedab244bbc2b8f1a328c5aa835d0f199c463466cbc4f3e87e57b2eab73337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e4414dcdb1792945ecbfeb249b250a8d2524656dd399db06e07e83eb9dd1c3b"
  end

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
