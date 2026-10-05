class Hyprmoncfg < Formula
  desc "Terminal-first monitor configurator and daemon for Hyprland"
  homepage "https://hyprmoncfg.dev/"
  url "https://github.com/crmne/hyprmoncfg/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "33f5fd0a737900cff36127c51e07652c86986fca376920d1034281b21b763ec0"
  license "MIT"
  head "https://github.com/crmne/hyprmoncfg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "d41b6a939c1a5e9b78dff662e7332dfb5c387d320f2bc1f9f84b26b8827232f5"
    sha256 cellar: :any,                 x86_64_linux: "dda1bc904ff78edc9680b90f8e8d52c45df2e653143be90290a73da7e3a85d78"
  end

  depends_on "go" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/crmne/hyprmoncfg/internal/buildinfo.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hyprmoncfg"
    system "go", "build", *std_go_args(ldflags:, output: bin/"hyprmoncfgd"), "./cmd/hyprmoncfgd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hyprmoncfg version")

    # `profiles` only needs hyprctl on PATH; listing reads the local profile store.
    (testpath/"bin/hyprctl").write "#!/bin/sh\nexit 0\n"
    chmod 0755, testpath/"bin/hyprctl"
    ENV.prepend_path "PATH", testpath/"bin"
    assert_match "No saved profiles", shell_output("#{bin}/hyprmoncfg --config-dir #{testpath}/cfg profiles")
    assert_predicate testpath/"cfg/profiles", :directory?
  end
end
