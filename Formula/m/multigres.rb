class Multigres < Formula
  desc "Vitess for Postgres"
  homepage "https://multigres.com"
  url "https://github.com/multigres/multigres/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "4b083b1342983a1e0c0fdf18d3fe346be511a53609b8238fa1d96d3c5b7807da"
  license "Apache-2.0"
  head "https://github.com/multigres/multigres.git", branch: "main"

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
    assert_match "Manage cluster lifecycle", shell_output("#{bin}/multigres --help")
    assert_match "PostgreSQL server instances", shell_output("#{bin}/pgctld --help")
    assert_match "connection pooling", shell_output("#{bin}/multipooler --help")
  end
end
