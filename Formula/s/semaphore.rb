class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.15.tar.gz"
  sha256 "0002ca5b17c0f180934886c942a12f0b21e49974344b9c7268ffe4cfa8b9c6d2"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3533b198e47411daef789158dedce01419a7fb18f9fc4042b72820d985375091"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f0fdbf5774fdd5c7802dd1a3009bf37f50c1bf521045afba57cd8f62625bab9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f0fdbf5774fdd5c7802dd1a3009bf37f50c1bf521045afba57cd8f62625bab9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "849abaef4d6ede692cafd67d85da2fd76c4edd64b5bc9ce8e6f59aaac2db2394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e923421520b159a7e0ce68cc2e189f5ac3970b1263bc970149be1337e48a6c56"
  end

  depends_on "go" => :build
  depends_on "go-task" => :build
  depends_on "node" => :build

  def install
    system "task", "deps:fe", "build:fe"

    ldflags = %W[
      -s -w
      -X github.com/semaphoreui/semaphore/util.Ver=#{version}
      -X github.com/semaphoreui/semaphore/util.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "netgo"), "./cli"

    generate_completions_from_executable(bin/"semaphore", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/semaphore version")

    output = shell_output("#{bin}/semaphore users list 2>&1", 1)
    assert_match "Cannot Find configuration", output
  end
end
