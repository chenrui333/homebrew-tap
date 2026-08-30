class Dotr < Formula
  desc "Dotfiles manager that is as dear as a daughter"
  homepage "https://github.com/uroybd/DotR"
  url "https://github.com/uroybd/DotR/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "49b841077fc81b1f0bf1a3d24cb3cbe215df575afd54da7ed698a7eb1aab773e"
  license "MIT"
  head "https://github.com/uroybd/DotR.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6279b73e7fc5b4cb1f771cd187d62fb2a970e8ab8ee207f80b02bfa74ec86f13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c8ae559eb9e96f5bc4179b2ffbabd40e011de0d8610cafee0784f45a52420a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a44311e19aeb47461f6b4bc4489520e4ae1e009a804118689e84e5ef930af59"
    sha256 cellar: :any,                 arm64_linux:   "97551b560048a3edbcc088f03d6f883d2d32e1eb7b8b8b5f812e5d13535558a2"
    sha256 cellar: :any,                 x86_64_linux:  "d1d06ca4c336876bd70a3054a91214a06eb9f441c88990887ae6cdfe2b88cde8"
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
