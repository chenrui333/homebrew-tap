class Multigres < Formula
  desc "Vitess for Postgres"
  homepage "https://multigres.com"
  url "https://github.com/multigres/multigres/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "4b083b1342983a1e0c0fdf18d3fe346be511a53609b8238fa1d96d3c5b7807da"
  license "Apache-2.0"
  head "https://github.com/multigres/multigres.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f1b2b516fc843a160ffda617cab5465f2facad2818cb4ac035c7257dde9101e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b7114ae6e95afaf0573109f233aa707dd9c8e588cd9cc54200dc9bc3e14b86a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e8c6495fc8df82022b01d1cde969f44b0e12f954f74e4bf3d7596dfcd8b131a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c20667ab957c27ac2c3b7b7ceb4a016943a2f23fe4b613f523a33e2e74ceb791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa844c293438ecac4ce1841f47069eaec44d63a18a1dbb2386a6dddfb4e18bc2"
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
