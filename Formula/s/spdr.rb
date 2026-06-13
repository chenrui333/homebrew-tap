class Spdr < Formula
  desc "Read-only DDR5 SPD decoder and semantic linter in Rust"
  homepage "https://github.com/The-Open-Memory-Initiative-OMI/spdr"
  url "https://github.com/The-Open-Memory-Initiative-OMI/spdr/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f0bf7a9d80b11885ce47e7288cde33df712a22ae0d1c393cda6c4ee0a308c5f7"
  license "Apache-2.0"
  head "https://github.com/The-Open-Memory-Initiative-OMI/spdr.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb12e8858bae4b47955f1964b203d3779b8dfcfccb01632246a5dfd47bea386d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44582988947e64d3a6c5e0befd710278dc5e9a6e94c24e15aa7ff30cf0cb7e59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71439bdf2e11020d59dbb3040a9b2e5cc007b48466144823c451622768c0398b"
    sha256 cellar: :any,                 arm64_linux:   "ee7afba624a65d59974e07e7eb40853012ad57fea5f388f1630e9a80d56e63e1"
    sha256 cellar: :any,                 x86_64_linux:  "55cd905028f379a0c666b6c67bbd56744ec54720cea884c57d03967ec7a8539a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "spdr-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spdr --version")
    output = shell_output("#{bin}/spdr not-a-real-command 2>&1", 2)
    assert_match "unrecognized subcommand", output
  end
end
