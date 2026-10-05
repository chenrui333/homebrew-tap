class Seamstress < Formula
  desc "Art engine and batteries-included Lua runtime"
  homepage "https://alanza.xyz/"
  url "https://github.com/robbielyman/seamstress/archive/refs/tags/v2.0.0-alpha+build.250109.tar.gz"
  version "2.0.0"
  sha256 "e61cda863afbf5c1555bbee35cdc5a3f0f8b1235451af2ac5a3a6e680eba4e02"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24581e9413a9d581c4926108bd4e880f627d06c0a6b29f5860ec0ad4c976780f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d921f2a44be80a5f708485664f07d20dd0b088ab99c300f12cad05f43cab8d65"
    sha256 cellar: :any_skip_relocation, ventura:       "32a28b1d7a5dcb213d086ce4da13538ee3d176820533d7a90f2ec5b28058a682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20ca9b29083bfdb0a8d5c54b9aa849ab722704b91e1d53137fc44266343d76fe"
  end

  depends_on "zig@0.13" => :build

  deny_network_access!

  def fetch
    configure_zig_sdk
    system "zig", "build", "--fetch"
  end

  def install
    configure_zig_sdk
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[
      --prefix #{prefix}
      -Doptimize=ReleaseSafe
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args
  end

  def configure_zig_sdk
    on_macos do
      developer_dir = buildpath/"CommandLineTools"
      (developer_dir/"SDKs").mkpath
      (developer_dir/"usr").make_symlink "#{MacOS::CLT::PKG_PATH}/usr" unless (developer_dir/"usr").exist?
      ENV["DEVELOPER_DIR"] = developer_dir.to_s
      ENV["HOMEBREW_DEVELOPER_DIR"] = developer_dir.to_s
    end
  end

  test do
    # error enabling logging! FileNotFound\nlogging disabled!
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "seamstress version: #{version}", shell_output("#{bin}/seamstress --version 2>&1")

    # `seamstress --test` needs busted built for Lua 5.4, but Homebrew's busted now targets Lua 5.5.
    (testpath/"test.lua").write <<~LUA
      print("seamstress-ok " .. _VERSION)
      os.exit(0)
    LUA
    assert_match "seamstress-ok Lua 5.4", shell_output("#{bin}/seamstress test.lua 2>&1")
  end
end
