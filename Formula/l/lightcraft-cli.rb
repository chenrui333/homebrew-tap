class LightcraftCli < Formula
  desc "Headless LightCraft photo library and raw developer, with MCP server"
  homepage "https://getartcraft.com/apps/lightcraft"
  url "https://github.com/storytold/lightcraft/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "a1273f4a9f68694ff1778b81d6e6e7e9de78f326c711ab57489770e8c6b76bff"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/lightcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d96cdd06a2eebf5f6f821098d586d1806f95172991221d348745171e8d484c84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22aaf916cfb01a094213c1252e99264cdd87c57291f423f2781c11be65862d8d"
    sha256 cellar: :any,                 arm64_linux:   "0834b0d32380d352cfa66b2dfcb6907a8e3b3fdb8b187005b77d18d23279799e"
    sha256 cellar: :any,                 x86_64_linux:  "f88b604f0ded5d9edb398bc1d02345effde54b54aed81f059b6110309c25483f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/lightcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lightcraft-cli --version")

    controls = JSON.parse(shell_output("#{bin}/lightcraft-cli controls --json"))
    assert_includes controls.map { |control| control["id"] }, "light.exposure"

    cp test_fixtures("test.jpg"), "in.jpg"
    system bin/"lightcraft-cli", "render", "in.jpg", "-o", "out.png", "--set", "light.exposure=1"
    assert_equal "\x89PNG".b, (testpath/"out.png").binread(4)
  end
end
