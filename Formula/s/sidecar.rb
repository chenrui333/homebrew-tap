class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v0.83.0.tar.gz"
  sha256 "4acc024d7d23d41d19467f6a50fba9bb18435138bb2e90f9928b0f427e88a3f6"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06b85939038c15151fe0d5dbb6a2f05a58c39d87e76a1a5018cb91d9cdc1e08e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fd9bb2640b7753419a9c56192bfad292b5b23c83a09ed35b0362543261640f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "409963491d8c648f0dbe559fe228998e6fe11639d72579b0f47de9dcb0667e9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fe65d9c89cde6586999cd1911b3dedb8461e2cce726e6fdf7e8e4de27503932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e5184f8b6b3cb8f65dad4c4156b953c494286fba827ad3aff831a00a52033f4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"sidecar"), "./cmd/sidecar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sidecar --version")
    assert_match "sidecar requires an interactive terminal",
                 shell_output("#{bin}/sidecar --project #{testpath} 2>&1", 1)
  end
end
