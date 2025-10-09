class GoEnvsubst < Formula
  desc "Environment variables substitution for Go"
  homepage "https://github.com/a8m/envsubst"
  url "https://github.com/a8m/envsubst/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "01ca48a2beaeeda5b9fbca9c46bb9e9acc0e55354761d90e4beba5ca1c97aa8b"
  license "MIT"
  revision 1
  head "https://github.com/a8m/envsubst.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "101ec59adfdc0cb8a24fff682be46667e02a1414660ec2bb06dc0927990dd8fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "101ec59adfdc0cb8a24fff682be46667e02a1414660ec2bb06dc0927990dd8fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "101ec59adfdc0cb8a24fff682be46667e02a1414660ec2bb06dc0927990dd8fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d05eb3c45b1abe6135a9669c8c6f1896aea79c362a4bb45193e2b6f9833830f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e6b8521e0ec064a968558a7a4849290aa06097a57af205185e6e72848fa73ed"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/envsubst"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      Hello, $NAME!
      Your home directory is ${HOME}.
      Your favorite color is ${COLOR:-blue}.
      PATH=$PATH
    EOS

    ENV["NAME"] = "Homebrew"

    output = pipe_output(bin/"go-envsubst", (testpath/"test.txt").read)
    assert_equal <<~EOS, output
      Hello, Homebrew!
      Your home directory is #{Dir.home}.
      Your favorite color is blue.
      PATH=#{ENV["PATH"]}
    EOS
  end
end
