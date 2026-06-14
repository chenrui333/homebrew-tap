class Narr < Formula
  desc "Download audio tracks from Netflix to sample your favorite shows"
  homepage "https://github.com/IljaN/narr"
  url "https://github.com/IljaN/narr/archive/refs/tags/0.2.0.tar.gz"
  sha256 "f5913c56d842ba37802fa792a30d8fbe10a608d8a3133a1d593ccc9a22b70f02"
  license "Unlicense"
  head "https://github.com/IljaN/narr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07f59378bfd14f66883026cba48934dc04c83da7ad87fec286a9123f09a32d7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07f59378bfd14f66883026cba48934dc04c83da7ad87fec286a9123f09a32d7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07f59378bfd14f66883026cba48934dc04c83da7ad87fec286a9123f09a32d7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f4d77a62ed810eb671b66a41e31b9add2f5f495e8077504fff4d8caa27936a3"
    sha256 cellar: :any,                 x86_64_linux:  "87f16b18a7bc20f0913449c0f538b28059d31e8c75be0a5cdd51aa68048503fc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/narr --version")
    output = shell_output("#{bin}/narr --not-a-real-option 2>&1", 255)
    assert_match "not-a-real-option", output
  end
end
