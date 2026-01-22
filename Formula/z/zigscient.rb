class Zigscient < Formula
  desc "Zig Language Server"
  homepage "https://github.com/llogick/zigscient"
  url "https://github.com/llogick/zigscient/archive/refs/tags/0.14.15-3.tar.gz"
  sha256 "5c295fd98b957092cfffed76337c7bc59e78bf4c112577845efaf90454ecc048"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e05054facb33e0c8d1986cfd15d0f42f939976c6b6865bbb48464ea7abbe6fad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "726e76ec2838c4a27fb89bca6bd2dac84e19253fe8d6a8f74c1e3e79464394e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f90de87061d01db4acc9839978e532f5c3b617e9313f531994e405379c544311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6482771d62c4864593c3843907234d52b884dceb2fb7836455b13447f7ec1023"
  end

  depends_on "zig@0.14" => :build

  def install
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

  test do
    assert_match version.to_s, shell_output("#{bin}/zigscient --version")

    output = shell_output("#{bin}/zigscient --show-config-path 2>&1")
    assert_match "path to the local configuration folder will be printed instead", output
  end
end
