class Filessh < Formula
  desc "Fast and convenient TUI file browser for remote servers"
  homepage "https://github.com/JayanAXHF/filessh"
  url "https://github.com/JayanAXHF/filessh/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "3e26169f9968edd5005d7f2df9f7c4cf14b08c225d6766d9a51f3b6f73d42ca4"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/JayanAXHF/filessh.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1f3056e3d60c3b64895b2a8c66b15103ba6dc6a2a635ab8351720b3f188e989"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31c1323f57fa611068fd8f1702a9df2ab6095c282f37e100b1ed4811aa2f3895"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba5671241b88d199224eaee36e32e8df5ca30dc3454505ff9cdb03329624c326"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bd8f64a045e43e6a275e69f624b0fb2ac9185430e275ec6356552790aa25779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fb32e38ece0b00871a2cd0128898810cf64cff82f6b0dd6d04a95984cd86a60"
  end

  depends_on "rust" => :build

  def install
    ENV["VERGEN_GIT_BRANCH"] = "main"
    ENV["VERGEN_GIT_COMMIT_TIMESTAMP"] = time.iso8601
    ENV["VERGEN_GIT_SHA"] = tap.user

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filessh --version")
    assert_match "You must provide a host", shell_output("#{bin}/filessh connect 2>&1", 1)
  end
end
