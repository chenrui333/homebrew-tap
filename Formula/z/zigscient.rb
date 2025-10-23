class Zigscient < Formula
  desc "Zig Language Server"
  homepage "https://github.com/llogick/zigscient"
  url "https://github.com/llogick/zigscient/archive/refs/tags/0.14.15-2.tar.gz"
  sha256 "3624683cf6d91b98ec78d425948dfd420253ae93495336ddb4658fa1a05ece45"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d3f0e23aec22feb5eacc03b18d62ab65ac0e742a4747e9365e7f60f409b5854"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d7c611cdafcc8dbdf930863af88596ce398010d91f0ea52c5f3aea489722a80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "599fe46013efaa290fb55f160db05fe5779e54946a3ba83a9e246ef50b9cb701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b470c4aa8ec82df9cdec15820dcbb26e3a0fc0fb3f10219a9db9b669237a907"
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
