class Await < Formula
  desc "Small binary that runs a list of commands in parallel and awaits termination"
  homepage "https://github.com/slavaGanzin/await"
  url "https://github.com/slavaGanzin/await/archive/refs/tags/2.5.0.tar.gz"
  sha256 "85804dabbc605354d77ff46a85a81288800cda08c9489bbe921bc019a7b704ac"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4d5e5f9524ac82e2ae37422699f71299a050102f2e38676fa93f178e2a85008"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bdd9e30d55ea810662395c7a802d91848f522dabf7cddb2b06c163a33655e8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14ed6fc7a1d9c063fc170f1a999936457cc0e3dd897ea57b362c36ea0741d747"
    sha256 cellar: :any_skip_relocation, sequoia:       "dd115bb3eff9654c18dc6fed42f24c76197eeee4daad38671c7bf52f00853d5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b534e513c3cf2e78100c178a1993a10ceeb4f46176a8d85a5d7f450ceb2d0ff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dfa27d03e0c85d0021cd29632a9c4142058de0292e753a3acaf4d4016d72ab1"
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
