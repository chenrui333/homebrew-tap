class Dotr < Formula
  desc "Dotfiles manager that is as dear as a daughter"
  homepage "https://github.com/uroybd/DotR"
  url "https://github.com/uroybd/DotR/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "1d2698fd96e6a9390a19a720350f6922bec84d80b1105b35d7eb53d1cf6a4e0e"
  license "MIT"
  head "https://github.com/uroybd/DotR.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9636671add37d49857eb3b81af66cc72cc3218235a0559f8977fd8d9d5028313"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1caaace9aed7964f574b3bc77f59376e40b227c03140fd7596073a835d1fd3c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d338c939349c6f715b1faa8bd4ddc11ccc1691c11c70921c0a3c1ad7e1f5ceb0"
    sha256 cellar: :any,                 arm64_linux:   "70b246e99b570b9f5e3e6643daf23127fff0b935e9e81d6ca4790dad60e0a45c"
    sha256 cellar: :any,                 x86_64_linux:  "2f11b5f12c851872c47c7665edd616a72326bf077bc4f2f9c4f8942d6961972c"
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
