class LightpandaV8 < Formula
  desc "Fork-specific V8 archive and Zig module layout for Lightpanda"
  homepage "https://github.com/lightpanda-io/zig-v8-fork"
  url "https://github.com/lightpanda-io/zig-v8-fork/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "16c30c266dea67530c9345754ba121a027e0e7c2745b131c1577f6e411b4c0cd"
  license "MIT"
  head "https://github.com/lightpanda-io/zig-v8-fork.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "519f4dd6b690a57422f869ebd5b8e80c2c9cf5a2c1333fac6739f75edfa32198"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "468568d6230a5b6d8414c0abcab422a2bb4b2b2d252dfc2fd414d80d345a3578"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e31458b6fc8ca05b3d284175d6d7266ab43466530ed24a7dbd03dbb0fbfd668"
    sha256 cellar: :any_skip_relocation, sequoia:       "da327e8e9db34a087160f11e32a331062309162c0e692a6649697e1fad6c2aa1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56ca40000c6024c086a8bb1c0c22703b9dfb521ce574e0dbd1424dc96f09db02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afbfa27d514e25c7e97089dfed618c341ab52455cf042210bb3ff5a7cb39e492"
  end

  if OS.mac? && Hardware::CPU.arm?
    resource "libc_v8" do
      url "https://github.com/lightpanda-io/zig-v8-fork/releases/download/v0.3.3/libc_v8_14.0.365.4_macos_aarch64.a"
      sha256 "c9fb1286e07447d097a704d5ff1b305172f359796e20aaf132deee2d502acca0"
    end
  elsif OS.mac? && Hardware::CPU.intel?
    resource "libc_v8" do
      url "https://github.com/lightpanda-io/zig-v8-fork/releases/download/v0.3.3/libc_v8_14.0.365.4_macos_x86_64.a"
      sha256 "ea2037790c93bb45e8156219fb44638bb9f10ed6cbd988b62d88d39204b40167"
    end
  elsif OS.linux? && Hardware::CPU.arm?
    resource "libc_v8" do
      url "https://github.com/lightpanda-io/zig-v8-fork/releases/download/v0.3.3/libc_v8_14.0.365.4_linux_aarch64.a"
      sha256 "1427c46de6da4918597640a720e2ba725410f41dcac57626291dd025a5968f69"
    end
  else
    resource "libc_v8" do
      url "https://github.com/lightpanda-io/zig-v8-fork/releases/download/v0.3.3/libc_v8_14.0.365.4_linux_x86_64.a"
      sha256 "b875439b3df025a2da510388559fe66c4454ed660bc38101c54dd55af0b5d0c7"
    end
  end

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
