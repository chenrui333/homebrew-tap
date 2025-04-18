class Buffrs < Formula
  desc "Modern protobuf package management"
  homepage "https://github.com/helsing-ai/buffrs"
  url "https://github.com/helsing-ai/buffrs/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "984d2097529ca9cdb24c6553cf55e1001275864462dd06a8de4f338c339a0fff"
  license "Apache-2.0"
  head "https://github.com/helsing-ai/buffrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6078eec6d3bae61c695542d4da4a6a47cc52a46311d64cbeeed3cc33a8907924"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba2986cead92adbd99b256a11e4eda99f5f4946e356a3b5a1394a2157576ae84"
    sha256 cellar: :any_skip_relocation, ventura:       "62a5f1bf95e4ef4cbc3bcceab051fa6755071fd8cbf2939ffadde7a8f31dee82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7b3f54b848abb0839d72afaa487e18905082c0fbd0e7bd72efb92c9e68cf70b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/buffrs --version")

    system bin/"buffrs", "init"
    assert_match "edition = \"#{version.major_minor}\"", (testpath/"Proto.toml").read

    assert_empty shell_output("#{bin}/buffrs list")
  end
end
