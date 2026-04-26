class Zigscient < Formula
  desc "Zig Language Server"
  homepage "https://github.com/llogick/zigscient"
  url "https://github.com/llogick/zigscient/archive/refs/tags/0.16.1.tar.gz"
  sha256 "e6f85df3869f8c00bb76ad84232f6186ad3ea456ff2e1b6b85adac851a2f84f9"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e66e4efcd7eae5ab3dbcd7f7f867aa24211654e4fc482855a13e0cf0d909b01d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1575e6c252d4fc087ee94bf432362d8598163ab9492fdd48412e548e6caee7c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35da05741180ea7b06c2f8f0993d685c0efb420367bb151da4cdf389c78a0fb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11436a64693466dfd27564d3f92c8761fc18d1703e3b476ef620e770c11c4217"
  end

  depends_on "zig" => :build

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?

    zig = "zig"
    system zig, "build", *args, *std_zig_args(release_mode: :safe)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zigscient --version")

    output = shell_output("#{bin}/zigscient env")
    assert_match "\"config_file\":", output
  end
end
