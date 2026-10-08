class LightpandaV8 < Formula
  desc "Fork-specific V8 archive and Zig module layout for Lightpanda"
  homepage "https://github.com/lightpanda-io/zig-v8-fork"
  url "https://github.com/lightpanda-io/zig-v8-fork/archive/refs/tags/v0.6.0-temporal.tar.gz"
  version "0.6.0-temporal"
  sha256 "5df144a3214badb47545fbcb06ba7d75c360a1c3d8524fffd8ef77058315fc56"
  license "MIT"
  head "https://github.com/lightpanda-io/zig-v8-fork.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c616597e505f2319636141e081c8e655b22a75724b9f7511c09cf01cb25a77d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2ae22bdb6876f3d3d75891bd8aa2b32ee960a58c9d313bc425f861d082351d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2639ae08e98dfa16d5fdd9b19086266063a120367c0f30ef67ae861f106c64af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "568713479e878d83c294e6469371a87c88466acf5963811dfa45973408afaa92"
  end

  if OS.mac? && Hardware::CPU.arm?
    resource "libc_v8" do
      url "https://github.com/lightpanda-io/zig-v8-fork/releases/download/v0.5.9/libc_v8_15.5.35.13_macos_aarch64.a"
      sha256 "dc14027e53df891399522f6089296acfdf37207afaca1e49dd05c446d3fc475f"
    end
  elsif OS.mac? && Hardware::CPU.intel?
    resource "libc_v8" do
      url "https://github.com/lightpanda-io/zig-v8-fork/releases/download/v0.5.9/libc_v8_15.5.35.13_macos_x86_64.a"
      sha256 "d0e23a65889c000a33cfc9048f3a35f55a69c6b06d65067c775cae19068ca2a5"
    end
  elsif OS.linux? && Hardware::CPU.arm?
    resource "libc_v8" do
      url "https://github.com/lightpanda-io/zig-v8-fork/releases/download/v0.5.9/libc_v8_15.5.35.13_linux_aarch64.a"
      sha256 "30edeb56ec8374364ccbb50965fc6671f3c95addf980b367d6bd4ef9d96cde34"
    end
  else
    resource "libc_v8" do
      url "https://github.com/lightpanda-io/zig-v8-fork/releases/download/v0.5.9/libc_v8_15.5.35.13_linux_x86_64.a"
      sha256 "eed0fa1a97d815e2f5000e7a29153d62e06ef92d2d80a024598701394e9322cb"
    end
  end

  deny_network_access!

  def install
    module_root = pkgshare/"zig-v8-fork"
    module_root.mkpath
    cp_r Dir["*"] + Dir[".*"] - %w[. ..], module_root

    build_zon = module_root/"build.zig.zon"
    build_zon_content = build_zon.read
    unless build_zon_content.sub!(
      /    \.dependencies = \.\{\n.*?    \},\n(?=    \.paths = \.\{)/m,
      "    .dependencies = .{},\n",
    )
      odie "Failed to rewrite zig-v8-fork dependency stanza"
    end
    build_zon_content.gsub!("\"README\",", "\"README.md\",")
    build_zon.atomic_write build_zon_content

    lib.install resource("libc_v8").cached_download => "libc_v8.a"
  end

  test do
    module_root = pkgshare/"zig-v8-fork"
    assert_path_exists module_root/"build.zig"
    assert_path_exists module_root/"build.zig.zon"
    assert_path_exists module_root/"src/v8.zig"
    assert_path_exists lib/"libc_v8.a"

    build_zon = (module_root/"build.zig.zon").read
    assert_match ".dependencies = .{},", build_zon
    assert_match "\"README.md\",", build_zon
    assert_match "current ar archive", shell_output("file #{lib}/libc_v8.a")
  end
end
