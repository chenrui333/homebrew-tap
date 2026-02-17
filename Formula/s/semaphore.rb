class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.3.tar.gz"
  sha256 "2181c7b33ca9e4e351a303b7e18ca5acac4ebce29f006de1fd2307955d270a9d"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "018eb60e57b306b5f053bd55394fa014d2f66d0cd4daa6a21edc91af33e9cae4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "018eb60e57b306b5f053bd55394fa014d2f66d0cd4daa6a21edc91af33e9cae4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1829d83c31473df3bde4d87d00f802f4849974473b3c7dcc32f59df1b5ebb568"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e845950fc473e23ed57982b525586409fc02a11b6903f969a7b0f924d6a6830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4b011ec766cc94c094e3be8b6bab94d23260cf704422902094a1921123f3cd5"
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
