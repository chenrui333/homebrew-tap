class Multigres < Formula
  desc "Vitess for Postgres"
  homepage "https://multigres.com"
  url "https://github.com/multigres/multigres/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "4b083b1342983a1e0c0fdf18d3fe346be511a53609b8238fa1d96d3c5b7807da"
  license "Apache-2.0"
  head "https://github.com/multigres/multigres.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5f3d13f4c2c187c10202e418495029d2763794a3ec1edbeabc6d7678ffa949b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1d5cf231267eeb0128a4da7e734ea08c870915baef47cdc116f7bd5a5a3f817"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5cc9d91d2ed995708a92e982270c63f829ece02fbec72ebc09a324fccf7344d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "143d5848dd733eefdd845079a09bcdc68e44e5577627e46d0c6c9c076014261c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b813777cb5a618911bb0331442035d6f84ed9c80b3e1946f1d7c8cc11ec7dc63"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    %w[
      multiadmin
      multigateway
      multigres
      multiorch
      multipooler
      pgctld
    ].each do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/cmd), "./go/cmd/#{cmd}"
      generate_completions_from_executable(bin/cmd, shell_parameter_format: :cobra)
    end
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    %w[multigres pgctld multipooler].each do |cmd|
      output, status = Open3.capture2e(bin/cmd, "--not-a-real-option")
      refute_predicate status, :success?
      assert_match "not-a-real-option", output
    end
  end
end
