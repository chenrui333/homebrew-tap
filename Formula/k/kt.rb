class Kt < Formula
  desc "Kafka command-line tool that likes JSON"
  homepage "https://github.com/fgeller/kt"
  url "https://github.com/fgeller/kt/archive/refs/tags/v13.1.1.tar.gz"
  sha256 "75031bd1d63b08b4f3d8e4b59eb1c9157d21d69f483bb1355933dc09f50f888d"
  license "MIT"
  head "https://github.com/fgeller/kt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85961d3a6eb74c8dd3ffccbdcd3a373bd61ef4999fd4d7d45ef58ed9c7a169ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85961d3a6eb74c8dd3ffccbdcd3a373bd61ef4999fd4d7d45ef58ed9c7a169ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46f4a2f906266bdcd7de68e52a1c2adadb40bc22e8b11f9519ae153f4bd2ac82"
    sha256 cellar: :any,                 x86_64_linux:  "9a2193242a24600041abf0d1096d86c94f1b4c3324f8d43c484ab115315f682a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.buildVersion=#{version} -X main.buildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kt --version")

    (testpath/"auth.json").write '{"mode":"Kerberos"}'
    output = shell_output("#{bin}/kt produce -topic greetings -auth #{testpath}/auth.json 2>&1 </dev/null", 1)
    # spellchecker:ignore-next-line
    assert_match 'failed to setup auth err=unsupport auth mode: "Kerberos"', output
  end
end
