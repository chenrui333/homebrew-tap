class Await < Formula
  desc "Small binary that runs a list of commands in parallel and awaits termination"
  homepage "https://github.com/slavaGanzin/await"
  url "https://github.com/slavaGanzin/await/archive/refs/tags/2.7.0.tar.gz"
  sha256 "a9f3d4184a0a459a9cc4add27d7a3c364e85244e5d1cc6c3b999b5d22d04f6e9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5a64d12e99c4ee982e91dcbbec80751b642ad0922d0bfad5a268f3a9c8995e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e61474fae15dc725f7fb62b0011f3d5c58d1e4c7323debea500dd04079c566a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d291f49824e886f0e9ce88a389837edcf838365a7dee57640e0added3726c9e"
    sha256 cellar: :any_skip_relocation, sequoia:       "674e0e4646b05bfae6652def2a00b88f2c4f95c4f4cd086d5d17a276110dd7cc"
    sha256 cellar: :any,                 arm64_linux:   "97e9729f2b20dd845f39edfa04286f00df803893263d7eb28a91791fe53473ea"
    sha256 cellar: :any,                 x86_64_linux:  "f17a12ca0d308a7bd0075168080645619c4a80781d66a77f3a70bed6b1baef8b"
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
