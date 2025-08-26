class Await < Formula
  desc "Small binary that runs a list of commands in parallel and awaits termination"
  homepage "https://github.com/slavaGanzin/await"
  url "https://github.com/slavaGanzin/await/archive/refs/tags/2.1.0.tar.gz"
  sha256 "167ec2e23edc6213abb192601611d60c87dd4d3f3796a9d3d560fe214c1f2807"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea6f636e6e06e299d37a7b1464e98171920eac7fa8437fa495675efb603b0e5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac253af762ea5eef45086421d0c9525d15caa72f2b22d0f592758bd1605bd328"
    sha256 cellar: :any_skip_relocation, ventura:       "85aa5162669862ce6e22ded2860fc0ca1c03073431dfe62e63e857b63c81c10c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fcb9caf72f9fb89cde6a3fe093451faadb98871c59042082531bf026204e5f6"
  end

  def install
    # patch version
    inreplace "await.c", "1.0.9", version.to_s

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
