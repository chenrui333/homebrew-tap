class Konfigo < Formula
  desc "Merge and transform configuration files across multiple formats"
  homepage "https://github.com/ebogdum/konfigo"
  url "https://github.com/ebogdum/konfigo/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "4bcf852ca67d22d82f2c6a8b3119100b7dfb8e20228d4104478138aab8e6cbbd"
  license "MIT"
  head "https://github.com/ebogdum/konfigo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7aec41d6badc3771aedcc16b309dfb4c2df04e47579b052324690cef892f0287"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aec41d6badc3771aedcc16b309dfb4c2df04e47579b052324690cef892f0287"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7aec41d6badc3771aedcc16b309dfb4c2df04e47579b052324690cef892f0287"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3abcd0610094dfe29070c679c82cb3bbe1e0bb7f0573c7a21e9bf64f080df04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14e9a0db0455a442b410dd5fde128e1d1fc35d0a7d9a5050db3cfc592084eccb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"konfigo"), "./cmd/konfigo"
  end

  test do
    (testpath/"config1.json").write <<~JSON
      {"a":1,"b":2}
    JSON
    (testpath/"config2.json").write <<~JSON
      {"b":3,"c":4}
    JSON

    output = shell_output("#{bin}/konfigo -s config1.json,config2.json -oj")
    assert_match '"a": 1', output
    assert_match '"b": 3', output
    assert_match '"c": 4', output

    help = shell_output("#{bin}/konfigo -h 2>&1")
    assert_match "Path to a schema file", help
  end
end
