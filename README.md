# Web Project Initiator

<div align="center">

[![Gitter chat][gitter-image]][gitter-url]
[![license][license-image]][license-url]


[gitter-url]: https://gitter.im/Petrucus/Web-Project-Initiator?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge
[gitter-image]: https://badges.gitter.im/Petrucus/Web-Project-Initiator.svg

[license-url]: https://github.com/Petrucus/Web-Project-Initiator/blob/master/LICENSE
[license-image]: https://img.shields.io/github/license/Petrucus/Web-Project-Initiator
</div>

WPI is a bash script that tries to automate some of the most boring and repetitive work needed during the Web Dev course I follow. The aim is to be a simple and focused on what is needed for the use-case.

For now the use-case is limited into two things. Fork repos to work on them and creating new repos/projects all-together.

All these are to be accomplished using Github.

### How do I use it?
- Create a Github account
- Create a PAT (Personal Access Token), following this:
https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
- Create environment variables for
  - github_access_token = YOUR_GITHUB_TOKEN
  - directory_to_use = PATH_TO_USE_IN_UNIX_SYNTAX
- Edit `Petrucus` within the script to match your own github account
