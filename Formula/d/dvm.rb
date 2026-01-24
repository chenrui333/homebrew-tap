class Dvm < Formula
  desc "Deno Version Manager"
  homepage "https://dvm.deno.dev"
  url "https://github.com/justjavac/dvm/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "ce52f153d7d11f9cec3904b2a22b7298576a76be2f93fb026f8b780e5770d2df"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef61b1766f3e3a4b0b4c1cb820c719f90934dc170ae506bd81bb53a36d4e2ebd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1158fc53f4de65792078574a45496e159ebb6b05b353c355db222143d262c281"
    sha256 cellar: :any_skip_relocation, ventura:       "daa0d1c9bdfd0afe75b98885efe83669d841adea0e343fab8b42c3e26509c62d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b066142ea84a0c696b8a2fa198b2765d86bd24f5332d1ff6fa351921d1205f8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dvm", shell_parameter_format: :clap)
  end

  test do
    ENV["HOME"] = testpath

    assert_match <<~EOS, shell_output("#{bin}/dvm info")
      dvm #{version}
      deno -
      dvm root #{testpath}/.dvm
    EOS

    assert_match version.to_s, shell_output("#{bin}/dvm --version")
  end
end
