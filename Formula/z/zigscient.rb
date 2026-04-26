class Zigscient < Formula
  desc "Zig Language Server"
  homepage "https://github.com/llogick/zigscient"
  url "https://github.com/llogick/zigscient/archive/refs/tags/0.16.1.tar.gz"
  sha256 "e6f85df3869f8c00bb76ad84232f6186ad3ea456ff2e1b6b85adac851a2f84f9"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2a797a9c790781adbda5cb315d8a7f74a3d9ae0d796561368d2d5a4736c84d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b6cadac97b011b9f2eacd3d08206a6b190edab88df11d9c9734f391b7d91129"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "947b8c2cb11dfbefb26da45ca0ce8d568fe5b9d069cd605e2b04a8b14f4f2bd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0fb0bb202e579e3ed0c54f6c9bc9b7c05e9473253c59f2275c0483133b1245d"
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
