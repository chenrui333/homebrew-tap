class GoEnvsubst < Formula
  desc "Environment variables substitution for Go"
  homepage "https://github.com/a8m/envsubst"
  url "https://github.com/a8m/envsubst/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "01ca48a2beaeeda5b9fbca9c46bb9e9acc0e55354761d90e4beba5ca1c97aa8b"
  license "MIT"
  head "https://github.com/a8m/envsubst.git", branch: "master"

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
