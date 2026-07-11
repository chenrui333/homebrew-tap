class Dotr < Formula
  desc "Dotfiles manager that is as dear as a daughter"
  homepage "https://github.com/uroybd/DotR"
  url "https://github.com/uroybd/DotR/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "b5b36577d3ca8673debac009b45888aa7ca5428ea5880673e27543496de80c8b"
  license "MIT"
  head "https://github.com/uroybd/DotR.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3aa55da27653425dbfbee6738674946c2d2a8c32dc7f08ab197d27af7ed94d49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91f38e389b202241e31df75aca30795702749d9c7e622245e7663eabfbfad4cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d47a17f4948f92629c7826cb5332adcc03d647b280aaa9c5ff63ceac6274a7d2"
    sha256 cellar: :any,                 arm64_linux:   "425d2228d36e3f82f67df6ba614ed8cfcfcf25ac926583a89e71e39e8e35ae33"
    sha256 cellar: :any,                 x86_64_linux:  "528800d3967d7f93f7ea153ef5b586a1433af73de7d32256ed9a38f91cbb803a"
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
