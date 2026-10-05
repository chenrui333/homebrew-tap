class LightpandaV8 < Formula
  desc "Fork-specific V8 archive and Zig module layout for Lightpanda"
  homepage "https://github.com/lightpanda-io/zig-v8-fork"
  url "https://github.com/lightpanda-io/zig-v8-fork/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "fc35ad8b6a49277adf7bf5184a78c1d9136cf2fb3a12a4ec047a999c73f8d55a"
  license "MIT"
  head "https://github.com/lightpanda-io/zig-v8-fork.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e368a7bd33b31f6462116738f51c062eee8df29f3cdb9cdbd289e20f152fdbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58febfb91a886648079c39e571e8b7eb8b498727756953abe4e60627ff38d734"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b9d0516c7dbda13563dc6f791335dc7c388e0c65bf5eb7e82e1f1860cef5f79"
    sha256 cellar: :any_skip_relocation, sequoia:       "c9e5a9da3e6a615b1f77feea32e679df1f2afef036fae0d01801d8d55204ca4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c3ba5f616fa47c9cc7d532343f06e2e4df5fe74db4e59708dae6a56f2ac6d50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2501828204e1fc00cc15bbfdda8c1bc1cf6025723837a27321ecda7a889c4be"
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
