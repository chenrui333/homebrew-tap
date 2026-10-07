class Tfjournal < Formula
  desc "Record Terraform runs with git context and timing"
  homepage "https://github.com/Owloops/tfjournal"
  url "https://github.com/Owloops/tfjournal/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "11648cf5e910890592da30ff028aa172c3eebc0e73a1a3eb11d206196df43dbc"
  license "MIT"
  revision 1
  head "https://github.com/Owloops/tfjournal.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e1aeedb6ac0b766d2d8263dfc357ea7231e43feda613532b9ecb4fd66f1b9f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e1aeedb6ac0b766d2d8263dfc357ea7231e43feda613532b9ecb4fd66f1b9f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c1a1f91c714bc764a315dd8ce81a590588bc795a237852ef6d25e5db221258b"
    sha256 cellar: :any,                 x86_64_linux:  "65aec61c9421fed2bfc7b4741dbc6dde2179fd3ded23fb7e826f0a22342cba69"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  deny_network_access!

  def fetch
    cd "web" do
      system "npm", "install", *std_npm_args(prefix: false)
    end
    system "go", "mod", "download"
  end

  def install
    cd "web" do
      system "npm", "run", "build"
    end
    rm_r buildpath/"server/dist" if (buildpath/"server/dist").exist?
    cp_r buildpath/"web/dist", buildpath/"server/dist"

    ldflags = [
      "-s",
      "-w",
      "-X main.version=#{version}",
      "-X main.commit=homebrew",
      "-X main.date=unknown",
    ].join(" ")

    system "go", "build", *std_go_args(ldflags:, output: bin/"tfjournal"), "."
    generate_completions_from_executable(bin/"tfjournal", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfjournal --version")

    bin_dir = testpath/"bin"
    path_env = "#{bin_dir}:#{ENV["PATH"]}"
    bin_dir.mkpath
    (bin_dir/"terraform").write <<~SH
      #!/bin/sh
      if [ "$1" = "workspace" ] && [ "$2" = "show" ]; then
        echo default
        exit 0
      fi
      echo 'aws_s3_bucket.demo: Creation complete after 1s [id=test]'
      echo 'Apply complete! Resources: 1 added, 0 changed, 0 destroyed.'
    SH
    chmod 0755, bin_dir/"terraform"

    system "git", "init"
    system "git", "config", "user.email", "test@example.com"
    system "git", "config", "user.name", "Test User"
    (testpath/"main.tf").write "terraform {}\n"
    system "git", "add", "main.tf"
    system "git", "commit", "-m", "init"

    with_env("HOME" => testpath.to_s, "PATH" => path_env) do
      system bin/"tfjournal", "--", "terraform", "apply", "-auto-approve"
    end

    output = with_env("HOME" => testpath.to_s) do
      shell_output("#{bin}/tfjournal list --json")
    end
    assert_match '"program": "terraform"', output
    assert_match '"status": "success"', output
    assert_match '"add": 1', output
  end
end
