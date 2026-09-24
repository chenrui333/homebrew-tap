class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.35.0.tar.gz"
  sha256 "3ddb12971a6a15010c8f74f5b08a7e3587967f0f81eaee2a156df5fe910475b1"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da9029426d951f99ace12b53a6d1182b769dd0dcf928efdd7902d4682bdac7ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfc5fa664a9832a4f2afd8579b5f9f4620e5b76f2ca73230657a3c299d858fc9"
    sha256 cellar: :any,                 arm64_linux:   "4e8230a7f985ff399a36dd3db04dfc1f8ef696be152a4bef2de416c80b7ffee7"
    sha256 cellar: :any,                 x86_64_linux:  "a729a1bb740878aaea7efce4860d7def4eac2fab91078ddcd6b7c079dca1c624"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jiq --version")

    (testpath/"data.json").write("{}\n")
    empty_path = testpath/"empty"
    empty_path.mkpath
    output = shell_output("PATH=#{empty_path} #{bin}/jiq #{testpath}/data.json 2>&1", 1)
    assert_match "jq binary not found in PATH.", output
  end
end
