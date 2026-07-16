class Dotr < Formula
  desc "Dotfiles manager that is as dear as a daughter"
  homepage "https://github.com/uroybd/DotR"
  url "https://github.com/uroybd/DotR/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "1d2698fd96e6a9390a19a720350f6922bec84d80b1105b35d7eb53d1cf6a4e0e"
  license "MIT"
  head "https://github.com/uroybd/DotR.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fa4abb8a9ed736abb3b2ffc6c2a080db800f03622f129578cf1c2fbb37c81ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c63d3e850d42a702e335d2793af8d4e103e5f761728916687b7cf9a30017b27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a69d5f2e9c5276811d0e33a08db9e2f34182c7a14300d5d8453ec3e165bcce4"
    sha256 cellar: :any,                 arm64_linux:   "af010ffae2759dd51be643e7488850a58e9adb4ec0caeabde62f39cf5c5b4be5"
    sha256 cellar: :any,                 x86_64_linux:  "7376e897db62818707e69fd81d1cdd3ee2030d3edb84ff40afa3957761b5f09b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"dotr", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dotr --version")

    system bin/"dotr", "init"
    assert_path_exists testpath/"config.toml"
    assert_path_exists testpath/".gitignore"
  end
end
