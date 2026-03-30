class Taws < Formula
  desc "Terminal-based AWS resource viewer and manager"
  homepage "https://github.com/huseyinbabal/taws"
  url "https://github.com/huseyinbabal/taws/archive/refs/tags/v1.3.0-rc.7.tar.gz"
  sha256 "c6bd15c5541a4b6a4accb780128642f0cca78c43c741adfbade48062a8f96b51"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be3e4f1a9d22b9713603282d7d057f4ec9a4b3e80185ecb0e3e0b50ab726c051"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b9007db6dbf2c4266db254cf3382a42e8e63842efa018f5dd0ff95473cd9c09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7b098bed9af832921e45a96f64fa65e8713d9735c0f380e0b1a9de77264aa80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f33aab69b78f18a6b8973edad39550f2eeb3f19f5b3d133661c08f93b198c53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "860c8b0e5d5b11c61977a9abb43e0c8baeedbb0786c67ed0e6860979693cc2b9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
    generate_completions_from_executable(bin/"taws", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin/"taws"} --version")

    output = shell_output("#{bin/"taws"} completion bash")
    assert_match "taws__completion", output
    assert_match "--profile", output
  end
end
