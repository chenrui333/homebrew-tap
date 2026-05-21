class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "6c7411df851832fecddf6f0e67e5297e621d6dd7bb248af402b3146d006a4b46"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d78057f02dbcd44e5db8639875aecb9fb76427596c88b90f7990555e9acbe05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d78057f02dbcd44e5db8639875aecb9fb76427596c88b90f7990555e9acbe05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d78057f02dbcd44e5db8639875aecb9fb76427596c88b90f7990555e9acbe05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef052822c02f9562c9ba179614af8bca2d33fc3aa3a5cde9703bc5de2811c0ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86c6ec02013640c4388c4db3ee2b846af0034794566c49ff1299e098a5f2a9d1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    assert_match "#compdef lfk", shell_output("#{bin}/lfk completion zsh")
  end
end
