class Poop < Formula
  desc "Performance Optimizer Observation Platform"
  homepage "https://github.com/andrewrk/poop"
  url "https://github.com/andrewrk/poop/archive/refs/tags/0.5.0.tar.gz"
  sha256 "b67d62c3583994fb262ccaf05094b215d3514d4d2935a25a3867dcab0cf89c93"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fed1c95224715c5421baf3eccc868c0e6986e1df2998dd3d9e26b039243c5b2c"
  end

  depends_on "zig@0.13" => :build

  deny_network_access!

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
    assert_match "Compares the performance of the provided commands", shell_output("#{bin}/poop --help")

    output = shell_output("#{bin}/poop --not-a-real-option 2>&1", 1)
    assert_match "unrecognized argument: '--not-a-real-option'", output
  end
end
