class Tfjournal < Formula
  desc "Record Terraform runs with git context and timing"
  homepage "https://github.com/Owloops/tfjournal"
  url "https://github.com/Owloops/tfjournal/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "11648cf5e910890592da30ff028aa172c3eebc0e73a1a3eb11d206196df43dbc"
  license "MIT"
  revision 1
  head "https://github.com/Owloops/tfjournal.git", branch: "main"

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "web" do
      system "npm", "install", *std_npm_args(prefix: false)
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
    generate_completions_from_executable(bin/"tfjournal", "completion")
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
