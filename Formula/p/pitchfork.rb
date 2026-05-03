class Pitchfork < Formula
  desc "Daemons with DX"
  homepage "https://github.com/endevco/pitchfork"
  url "https://github.com/endevco/pitchfork/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "df65c6371e555aea04095e12fad8e1035c83d749a6e8ccdfa9c2eec7a6d9ca13"
  license "MIT"
  head "https://github.com/endevco/pitchfork.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7991083888965ef81972a7218e3a92ed2ee3498b981b3542e36f9f3f3d7fa5a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8db68521102c24c0f4657852f71213f734fa7e7be8f997df50756620103fc303"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "799be7e6f44a421d910edf7662f2e6f661f2285e89d0ff21f0271cee86419448"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57719754af6b36f72348189ce2a0d0642c617038452b45f86c79ac8c666fffd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8b934eed4c9d2bc59448921b935a4d1f9c1391844067385f6d46a2e1c43bd2a"
  end

  depends_on "rust" => :build
  depends_on "usage" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pitchfork", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pitchfork --version")

    (testpath/"pitchfork.toml").write <<~TOML
      [daemons.test]
      run = "echo hello"
    TOML
    output = shell_output("#{bin}/pitchfork list 2>&1")
    assert_match "test", output
  end
end
