class Hyprmoncfg < Formula
  desc "Terminal-first monitor configurator and daemon for Hyprland"
  homepage "https://hyprmoncfg.dev/"
  url "https://github.com/crmne/hyprmoncfg/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "57dbdb4500b4c1bf872db6ba9ed63e80d49e40d786b8547d712bc5395bef67c7"
  license "MIT"
  head "https://github.com/crmne/hyprmoncfg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "092f20a08660b318d54a88e3e6bcf7c4eee8ae29dcac2e49cbe057aabdb123a5"
    sha256 cellar: :any,                 x86_64_linux: "e0ff892b200418906a623699bdb33be2a203a243220111f9cd20f8f6eb508d37"
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
