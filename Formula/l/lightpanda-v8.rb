class LightpandaV8 < Formula
  desc "Fork-specific V8 archive and Zig module layout for Lightpanda"
  homepage "https://github.com/lightpanda-io/zig-v8-fork"
  url "https://github.com/lightpanda-io/zig-v8-fork/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "151dd85b3ce28f48d11e11a9a6b2707661ad0f0f7862e1f435f6ff59006da505"
  license "MIT"
  head "https://github.com/lightpanda-io/zig-v8-fork.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "769a71d6dd53784cf93e622ebdb21e9e69eeff9f236f322ce73c7eb77651e8c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e88da63459cfb0b3ebd81e80443bf5ee042eb15fac0e4f758ed911bd78e9753"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10c211afb91252965416496c8780363e113a223e2e125b6932b663bd22546699"
    sha256 cellar: :any_skip_relocation, sequoia:       "7b7c297a483b3505e156544b0cc1217dc0f16e625675178b5a7c5b64ee754541"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44c21d7bd317968afed2ca08b134f23a389a7242c6bd567396367d1a0ae18744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5542f97a161db4b9cb9d45723bdcc6a7160d6b082a8eb1f19105387a8704e9e"
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
