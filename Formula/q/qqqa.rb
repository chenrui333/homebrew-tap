class Qqqa < Formula
  desc "Fast, stateless LLM for your shell: qq answers; qa runs commands"
  homepage "https://github.com/iagooar/qqqa"
  url "https://github.com/iagooar/qqqa/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "073cdcbc68c1f65a611cf06f84468db1fa4db176bd48795bc3841a5f224f1aa3"
  license "MIT"
  head "https://github.com/iagooar/qqqa.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    %w[qq qa].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} --version")
    end

    assert_match "Error: Missing API key", shell_output("#{bin}/qq 'test' 2>&1", 1)
  end
end
