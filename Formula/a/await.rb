class Await < Formula
  desc "Small binary that runs a list of commands in parallel and awaits termination"
  homepage "https://github.com/slavaGanzin/await"
  url "https://github.com/slavaGanzin/await/archive/refs/tags/2.11.0.tar.gz"
  sha256 "2333b49c56cbea5d033162a81ca7bc1aca9436500f1d32740c57901b1ce9a617"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88bf27be1571ae7d7481d21a15378d7d208a7c8341811b933d6d522755ab3083"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0645c782f9eba200ae8a826960a940712c7b97058cd1a5972126f5d596983dba"
    sha256 cellar: :any,                 arm64_linux:   "e701617e66aa4cd20a3a1242795146f474e3a29007c205e11cc983a7148c6b33"
    sha256 cellar: :any,                 x86_64_linux:  "f63bdfc15f7ba774a357d4b6eda43a1ed95abed88d374944c7399195284bdb6e"
  end

  def install
    system ENV.cc, "await.c", "-o", "await", "-lpthread"
    bin.install "await"

    bash_completion.install "autocompletions/await.bash" => "await"
    zsh_completion.install "autocompletions/await.zsh" => "_await"
    fish_completion.install "autocompletions/await.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/await --version")

    (testpath/"test_script.sh").write <<~SHELL
      #!/bin/bash
      echo "Test script running" > "#{testpath}/output.txt"
    SHELL
    chmod 0755, testpath/"test_script.sh"

    system bin/"await", "./test_script.sh"
    assert_path_exists testpath/"output.txt"
    assert_match "Test script running", (testpath/"output.txt").read
  end
end
