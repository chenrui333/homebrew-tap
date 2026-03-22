class GhRepoMan < Formula
  desc "Manage GitHub repositories interactively from the terminal"
  homepage "https://github.com/2KAbhishek/gh-repo-man"
  url "https://github.com/2KAbhishek/gh-repo-man/archive/refs/tags/v1.1.tar.gz"
  sha256 "4a5ec096ddba52f1062ea1aa746f6fa5f4c8d289922c5718ad23ac3368715d86"
  license "MIT"
  head "https://github.com/2KAbhishek/gh-repo-man.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c3ad69145fa5e8713fde0ce0782d0ef900c26579fe87ad48a8e35b7a477f72c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c3ad69145fa5e8713fde0ce0782d0ef900c26579fe87ad48a8e35b7a477f72c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c3ad69145fa5e8713fde0ce0782d0ef900c26579fe87ad48a8e35b7a477f72c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b164db103a3d7573712c9c9afa3294b0be5ea117064b4aaa082c0362364295eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e412366157a8401b81b6fc71e02198107e9044dc14241a1a8f980f213c3109cf"
  end

  depends_on "go" => :build
  depends_on "fzf"
  depends_on "gh"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    testbin = testpath/"test-bin"
    testbin.mkpath

    gh = testbin/"gh"
    gh.write <<~SH
      #!/bin/sh
      if [ "$1" = "repo" ] && [ "$2" = "list" ]; then
        cat <<'JSON'
      [{"name":"sample-repo","description":"Sample repository","url":"https://github.com/brewtest/sample-repo","stargazerCount":3,"forkCount":1,"watchers":{"totalCount":2},"issues":{"totalCount":0},"owner":{"login":"brewtest"},"createdAt":"2025-01-01T00:00:00Z","updatedAt":"2025-01-02T00:00:00Z","diskUsage":42,"homepageUrl":"","isFork":false,"isArchived":false,"isPrivate":false,"isTemplate":false,"repositoryTopics":[],"primaryLanguage":{"name":"Go"}}]
      JSON
        exit 0
      fi
      if [ "$1" = "api" ] && [ "$2" = "user" ]; then
        echo '{"login":"brewtest"}'
        exit 0
      fi
      echo "unexpected gh invocation: $*" >&2
      exit 1
    SH

    fzf = testbin/"fzf"
    fzf.write <<~SH
      #!/bin/sh
      IFS= read -r first_line
      printf '%s\n' "$first_line"
    SH

    git = testbin/"git"
    git.write <<~SH
      #!/bin/sh
      if [ "$1" = "clone" ]; then
        mkdir -p "$3/.git"
        exit 0
      fi
      echo "unexpected git invocation: $*" >&2
      exit 1
    SH

    chmod 0755, [gh, fzf, git]
    ENV.prepend_path "PATH", testbin

    home = Pathname(Dir.home)
    config_dir = home/".config"/"gh-repo-man"
    config_dir.mkpath
    config = config_dir/"config.yml"
    config.write <<~YAML
      repos:
        projects_dir: #{home/"projects"}
        per_user_dir: false
      integrations:
        post_clone:
          enabled: false
    YAML

    output = shell_output("#{bin}/gh-repo-man --user brewtest")
    assert_match "Successfully cloned sample-repo", output
    assert_path_exists home/"projects"/"sample-repo"/".git"
  end
end
