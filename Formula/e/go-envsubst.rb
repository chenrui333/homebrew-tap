class GoEnvsubst < Formula
  desc "Environment variables substitution for Go"
  homepage "https://github.com/a8m/envsubst"
  url "https://github.com/a8m/envsubst/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "01ca48a2beaeeda5b9fbca9c46bb9e9acc0e55354761d90e4beba5ca1c97aa8b"
  license "MIT"
  head "https://github.com/a8m/envsubst.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d221801c7ae74b0f49314ad529aad919c3c0edeec9bceabf259e21bc7a3d63f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eac6feb0720b61e287ed9936aad347c040c223a3d041aa9a857f1185edd71a29"
    sha256 cellar: :any_skip_relocation, ventura:       "ecfcffff8e8115289be50b93b61e9fae885bbb70aac95bb1b137fc15d28a2abf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b7f0bfa69cec179ffbde12a094b56bb2357b242a9ee3bab61aff0a5cffae5c9"
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
