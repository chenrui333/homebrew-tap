class Bttf < Formula
  desc "CLI tool for datetime arithmetic, parsing, formatting and more"
  homepage "https://github.com/BurntSushi/bttf"
  url "https://github.com/BurntSushi/bttf/archive/refs/tags/0.2.0.tar.gz"
  sha256 "5399df79e15ba48e94526319ec6baf4e4e9bbe983693adc4ba784294f0875e78"
  license any_of: ["Unlicense", "MIT"]
  head "https://github.com/BurntSushi/bttf.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "a85767458eecc1ac9ebe8121965e595705b8bfe851fc9a8c7387f6d305b69922"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "baf653687263b1095a311c9752ed34bd895a5f4eea18fbb35b130d69f95dbbd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9def42ce08eb584b6f3543749cca14edbc46fb351174b9c32add9d55e4b38f09"
    sha256 cellar: :any,                 arm64_linux:   "f25007463a4330a60f302a29ce815f7bb7586cd5570dce014400933e607eb10f"
    sha256 cellar: :any,                 x86_64_linux:  "7e7b8e2ab8c8e8f2a53817b9fddd99b7d72cc91ae91b5ead2ac48a0555983f6a"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bttf --version")
    assert_equal "2026-06-11\n", shell_output("#{bin}/bttf time fmt -f '%F' 2026-06-11")
  end
end
