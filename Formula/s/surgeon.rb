# framework: cobra
class Surgeon < Formula
  desc "Surgically modify a fork"
  homepage "https://github.com/bketelsen/surgeon"
  url "https://github.com/bketelsen/surgeon/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "d769bbb4640965c14eb00952f337d65f39c62886920d2171cc8b168abe4da9fd"
  license "MIT"
  head "https://github.com/bketelsen/surgeon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11db28902cb1a2f6761d0a43fae4e9ccaac031e84a4f2394332cd96618571869"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11db28902cb1a2f6761d0a43fae4e9ccaac031e84a4f2394332cd96618571869"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93c3905124b810506a19fd6d521a109aa9c5e5b02cd2f07f9bba4a5d4bdffd4a"
    sha256 cellar: :any,                 x86_64_linux:  "dec1dfaf46e966423701123491a2323893507e514a15929e23a31688ec29573d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X main.treeState=clean
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/surgeon"

    generate_completions_from_executable(bin/"surgeon", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surgeon --version")

    system bin/"surgeon", "init"
    assert_match "description: Modify URLS", (testpath/".surgeon.yaml").read
  end
end
