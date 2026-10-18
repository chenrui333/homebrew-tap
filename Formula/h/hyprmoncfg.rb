class Hyprmoncfg < Formula
  desc "Terminal-first monitor configurator and daemon for Hyprland"
  homepage "https://hyprmoncfg.dev/"
  url "https://github.com/crmne/hyprmoncfg/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "0fc15a78f92c0122d2f3139dad57946979cbf2d1dd18fc3fca2ff576acf1084d"
  license "MIT"
  head "https://github.com/crmne/hyprmoncfg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "ba33c1cda91c02a738774459ecc47df31edd72a4eb630b417cc8782f74be8553"
    sha256 cellar: :any,                 x86_64_linux: "aee237b6115bd0194b69d2cce6d0c24162fed2d17ad87ff6644b44a7c2c31a10"
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
