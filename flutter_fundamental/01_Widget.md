# Widget

## 플러터 UI에서 Widget이란?

- Flutter의 UI의 가장 기본적인 단위는 Widget.
- Flutter는 UI를 구성하는 각각의 요소가 모두 Widget으로 이루어져 있기 때문.

## Widget Tree

- Widget을 조합해서 사용하는 방식에 따라 전혀 다른 UI를 만들어 낼 수도 있고, 한 화면에서 만들어뒀던 Widget을 다른 화면에서 그대로 가지고 와 사용하는 것도 가능.
- 또한, Widget들 간에는 수평적인 관계도 존재하지만, 수직적인 관계도 만들어 낼 수 있음.
- 이런 Widget들 간의 관계를 나타낸 형태를 Widget Tree라고 한다.

## Stateless Widget / Stateful Widget

- 화면을 갱신 할 필요가 없는 정적인 화면을 구성할 때에는 Stateless Widget을, 특정한 상황에 따라 화면을 갱신할 필요가 있다면 Stateful Widget을 사용한다.
