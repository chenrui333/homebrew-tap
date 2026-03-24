class Jarl < Formula
  desc "Just Another R Linter"
  homepage "https://jarl.etiennebacher.com/"
  url "https://github.com/etiennebacher/jarl/archive/refs/tags/0.5.0.tar.gz"
  sha256 "7b1fd11adc3924fa71f3a4202a2a4a87f1c8d62944160adedba65eb8f01d1cda"
  license "MIT"
  head "https://github.com/etiennebacher/jarl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1f71774eb20e31455fd0934700403932811991d8df403e7249a65ef3c6e0ada"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebe2afff100048ae17ba00107c12662fb85a020e5b5022e589b7b6a66b93803f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abf93122df4083f3aa02ce335ae4a85ea2bbd7972dc993451ec335eef6284f94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00d335824a9a036a91b83a1d333b82e1e086152cbca19886d882aecfc5cfded6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4824f7e015241dcc34b144454cf686672785a96109350d9080efefb2690eb058"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/jarl")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jarl --version")

    (testpath/"test.R").write <<~R
      x = 1
      y <-2
      print( x +y )
    R

    output = shell_output("#{bin}/jarl check --select assignment #{testpath}/test.R 2>&1", 1)
    assert_match "Found 1 error", output

    output = shell_output("#{bin}/jarl check --select assignment --fix --allow-no-vcs #{testpath}/test.R")
    assert_match "All checks passed!", output
  end
end
